import { genkit, z } from 'genkit';
import { googleAI } from '@genkit-ai/google-genai';
import * as admin from 'firebase-admin';
import dotenv from "dotenv";
import path from "path";

dotenv.config({
  path: path.resolve(__dirname, "../../.env")
});

// --- CONFIGURATION ---
// Point to the local emulator so we don't need real credentials
process.env.FIRESTORE_EMULATOR_HOST = '127.0.0.1:8080';
process.env.GCLOUD_PROJECT = 'demo-wira'; 

admin.initializeApp();
const db = admin.firestore(); // Firestore database instance

// Initialize Genkit
const ai = genkit({
  plugins: [googleAI()],
  model: googleAI.model('gemini-2.5-flash'), // Changed to 1.5 as 2.5 is not standard yet
});

// --- TOOLS DEFINITION ---

// --- TOOL 1: SEARCH MYHIJAU ---
const searchMyHijauTool = ai.defineTool(
  {
    name: 'searchMyHijauDirectory',
    description: 'Finds government-approved green assets. Use for queries about products/suppliers.',
    inputSchema: z.object({
      query: z.string(),
    }),
    outputSchema: z.object({
      results: z.array(z.any()),
    }),
  },
  async ({ query }) => {
    console.log(`[TOOL] Searching MyHijau for: ${query}`);
    const snapshot = await db.collection('myhijau_assets')
      .where('keywords', 'array-contains', query.toLowerCase())
      .limit(5)
      .get();
    return { results: snapshot.docs.map(d => d.data()) };
  }
);

  // SINGLE KEYWORD SEARCH
  // const searchMyHijauTool = ai.defineTool(
  //   {
  //     name: 'searchMyHijauDirectory',
  //     // CHANGE 1: We explicitly tell the AI to use single keywords
  //     description: 'Finds green assets. Search by ONE keyword only (e.g. "solar", "chiller", "led").', 
  //     inputSchema: z.object({
  //       // CHANGE 2: Reinforce it in the schema description
  //       query: z.string().describe('A single keyword to search for.'),
  //     }),
  //     outputSchema: z.object({
  //       results: z.array(z.any()),
  //     }),
  //   },
  //   async ({ query }) => {
  //     // CHANGE 3: Simple cleanup to ensure lower case
  //     const term = query.toLowerCase().trim();
  //     console.log(`[TOOL] Searching MyHijau for keyword: "${term}"`);
      
  //     const snapshot = await db.collection('myhijau_assets')
  //       .where('keywords', 'array-contains', term)
  //       .limit(5)
  //       .get();
        
  //     if (snapshot.empty) {
  //         console.log("   -> No results found in DB.");
  //     } else {
  //         console.log(`   -> Found ${snapshot.size} results.`);
  //     }

  //     return { results: snapshot.docs.map(d => d.data()) };
  //   }
  // );

  // --- TOOL 2: TAX SIMULATOR ---
const taxSimulatorTool = ai.defineTool(
  {
    name: 'simulateTaxImpact',
    description: 'Calculates carbon tax liability. Use when user asks about tax cost or savings.',
    inputSchema: z.object({
      userId: z.string(),
      proposedTaxRate: z.number(),
    }),
    outputSchema: z.object({
      grossLiability: z.number(),
      savings: z.number(),
    }),
  },
  async ({ userId, proposedTaxRate }) => {
    console.log(`[TOOL] Simulating Tax for User: ${userId} at Rate: ${proposedTaxRate}`);
    const userDoc = await db.collection('users').doc(userId).get();
    const data = userDoc.data() || {};
    const gross = (data.totalEmissions || 0) * proposedTaxRate;
    const net = Math.max(0, gross - (data.gitaTaxCreditBalance || 0));
    return { grossLiability: gross, savings: gross - net };
  }
);

// --- TOOL 3: INVESTMENT SIMULATOR ---
const investmentSimulatorTool = ai.defineTool(
  {
    name: 'simulateInvestment',
    description: 'Calculates ROI and payback period for green assets (Solar, LED, etc).',
    inputSchema: z.object({
      assetType: z.string().describe('Type of asset (e.g. "solar", "led")'),
      estimatedCost: z.number().optional().describe('Cost in RM (optional, AI can estimate if missing)'),
    }),
    outputSchema: z.object({
      estimatedCost: z.number(),
      taxSavings: z.number(),
      paybackYears: z.number(),
      summary: z.string(),
    }),
  },
  async ({ assetType, estimatedCost }) => {
    console.log(`[TOOL] Simulating Investment for: ${assetType}`);
    
    // Mock Knowledge Base for MVP defaults
    const defaults: Record<string, { cost: number, annualSavings: number }> = {
      'solar': { cost: 50000, annualSavings: 15000 },
      'led': { cost: 10000, annualSavings: 4000 },
      'chiller': { cost: 150000, annualSavings: 45000 },
    };

    // Find closest match or default to solar
    const key = Object.keys(defaults).find(k => assetType.toLowerCase().includes(k)) || 'solar';
    const data = defaults[key];

    const cost = estimatedCost || data.cost;
    const annualSavings = data.annualSavings;

    // GITA Logic: 24% Corporate Tax Rate * 100% Investment Allowance
    const taxSavings = cost * 0.24; 
    const netCost = cost - taxSavings;
    const payback = netCost / annualSavings;

    return {
      estimatedCost: cost,
      taxSavings,
      paybackYears: parseFloat(payback.toFixed(1)),
      summary: `Asset: ${assetType}. Net Cost after Tax: RM${netCost}. Payback: ${payback.toFixed(1)} years.`
    };
  }
);

// --- TOOL 4: INDUSTRY BENCHMARK ---
const industryBenchmarkTool = ai.defineTool(
  {
    name: 'getIndustryBenchmark',
    description: 'Compares user carbon intensity vs industry average.',
    inputSchema: z.object({
      userId: z.string(),
    }),
    outputSchema: z.object({
      userIntensity: z.number(),
      industryAverage: z.number(),
      performance: z.string(),
    }),
  },
  async ({ userId }) => {
    console.log(`[TOOL] Benchmarking User: ${userId}`);
    const userDoc = await db.collection('users').doc(userId).get();
    const userData = userDoc.data();
    
    if (!userData || !userData.industry) throw new Error("User industry not found");

    // Calculate Intensity: (Total Emissions in kg) / Revenue
    // 1 Tonne = 1000 kg
    const userIntensity = (userData.totalEmissions * 1000) / userData.annualRevenue;

    // Fetch Industry Stat
    const statsDoc = await db.collection('industry_stats').doc(userData.industry).get();
    const avgIntensity = statsDoc.exists ? statsDoc.data()?.averageIntensity : 0.0005;

    // Compare
    const isGood = userIntensity < avgIntensity;
    const performance = isGood ? "Better (Lower Carbon)" : "Worse (Higher Carbon)";
    const percentDiff = ((Math.abs(userIntensity - avgIntensity) / avgIntensity) * 100).toFixed(0);

    return {
      userIntensity,
      industryAverage: avgIntensity,
      performance: `${percentDiff}% ${performance} than average.`
    };
  }
);

// --- HELPER: Fetch Invoice Details ---
async function getInvoiceContext(invoiceId: string | undefined): Promise<string> {
  if (!invoiceId) return "";

  try {
    const doc = await db.collection('invoices').doc(invoiceId).get();
    if (!doc.exists) return "\n[System] User selected an invoice, but ID was not found.";
    
    const data = doc.data();
    // Format the invoice data for the LLM to read
    return `
    \n=== SELECTED INVOICE CONTEXT ===
    Invoice ID: ${invoiceId}
    Vendor: ${data?.vendorName || "Unknown"}
    Date: ${data?.date || "N/A"}
    Items: ${JSON.stringify(data?.items || [])}
    Total Emissions: ${data?.carbonFootprint || 0} kgCO2e
    Fuel/Energy Type: ${data?.fuelType || "N/A"}
    Usage Amount: ${data?.usageAmount || 0} ${data?.usageUnit || ""}
    ================================
    `;
  } catch (error) {
    console.error("Error fetching invoice:", error);
    return "\n[System] Error retrieving invoice details.";
  }
}

// --- THE AGENT FLOW ---

const wiraBotFlow = ai.defineFlow(
  {
    name: 'wiraBot',
    inputSchema: z.object({ 
      userId: z.string(), 
      message: z.string(),
      invoiceId: z.string().optional(), 
    }),
    outputSchema: z.string(),
  },
  async ({ userId, message, invoiceId}) => {
    // Fetch user context
    const userDoc = await db.collection('users').doc(userId).get();
    const userData = userDoc.data();
    const userProfile = userData 
      ? `Industry: ${userData.industry}, Annual Emissions: ${userData.totalEmissions}t.` 
      : "Guest User";
    
    // 2. Fetch Selected Invoice (if any)
    const invoiceContext = await getInvoiceContext(invoiceId);
    console.log(`\n--- Processing Request for ${userId} ---`);
    console.log(`Invoice Context ${invoiceContext}`);
    console.log(`User Context: ${userProfile}`);

    const { text } = await ai.generate({
      prompt: `
        You are Wira, an AI Carbon Consultant.
        
        -- USER PROFILE --
        ${userProfile}
        
        -- ACTIVE CONTEXT --
        ${invoiceContext ? `User is asking about this specific invoice:${invoiceContext}` : "No specific invoice selected."}
        
        -- GOAL --
        If an invoice is selected, analyze it specifically. 
        - If they ask "how to reduce", look at the 'Items' or 'FuelType' in the invoice and suggest alternatives (use searchMyHijauDirectory if needed).
        - If they ask "is this good", compare the emission intensity.
        
        User Query: ${message}
      `,
      tools: [searchMyHijauTool, taxSimulatorTool, investmentSimulatorTool, industryBenchmarkTool], 
    });

    return text;
  }
);

// --- TEST RUNNER ---
// This part actually executes the code when you run the file
async function main() {
  const userId = 'user123';

  // TEST 1: General Chat - No Tool Usage Chit Chat
  // const response1 = await wiraBotFlow({ userId, message: "Hello, who are you?" });
  // console.log("Response 1:", response1);

  // TEST 2: Tool Usage - calls searchMyHijau tool
  // const response2 = await wiraBotFlow({ userId, message: "I need to buy a solar panel." });
  // console.log("Response 2:", response2);

  // TEST 3: Tool Usage (Tax Calculation)
  // const response3 = await wiraBotFlow({ userId, message: "If the carbon tax is RM 35 per tonne, how much will I pay?" });
  // console.log("Response 3:", response3);
  
  // TEST 4: Investment Simulator
  // console.log("\n--- TEST 4: Investment Simulator ---");
  // const res4 = await wiraBotFlow({ userId, message: "Is it worth investing in solar panels?" });
  // console.log("Response:", res4);

  // TEST 5: Industry Benchmark
  // console.log("\n--- TEST 5: Industry Benchmark ---");
  // const res5 = await wiraBotFlow({ userId, message: "How does my carbon footprint compare to other manufacturers?" });
  // console.log("Response:", res5);

  console.log("\n--- TEST 6: Invoice Context ---");
  // User selects the invoice and asks for help
  const res6 = await wiraBotFlow({ 
      userId, 
      message: "How can I reduce the carbon from this bill?", 
      invoiceId: 'invoice_abc' // <--- Simulating dropdown selection
  });
  console.log("Response:", res6);
}

main().catch(console.error);

