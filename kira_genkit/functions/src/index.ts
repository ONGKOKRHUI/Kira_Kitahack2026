import 'dotenv/config'; // additional installation
import {genkit, z} from "genkit";
import { googleAI } from '@genkit-ai/google-genai';
import path from "path";
import { readFile } from 'node:fs/promises'; 

const ai = genkit({
    plugins: [
        googleAI({ apiKey: process.env.GOOGLE_GENAI_API_KEY })
    ],
});

// define item schema
const ItemSchema = ai.defineSchema(
    'ItemSchema',
    z.object({
        // think about what attributes does an ItemSchema have, how are each described
        name: z.string().describe("The name of for this line item (eg: petrol, solar panel, diesal, biodegradable container)."),
        supplier: z.string().describe("The supplier of this invoice."),
        quantity: z.number().describe("The amount purchased for this item."),
        unit: z.string().describe("The unit (eg: single, kg, litres) purchased for this line item."),
        price: z.string().describe("The total price for this line item."),
        currency: z.string().default("MYR"),
        isGitaEligible: z.boolean().describe("Whether this item qualifies for GITA (Green Investment Tax Incentive)"),
        dateOfPurchase: z.boolean().describe("The date of this invoice issued in YYYY-MM-DD format.")
    })
);

// define array of items as a single invoie can have multiple item
const InvoiceResponseSchema = z.object({
    items: z.array(ItemSchema),
    totalAmount: z.number(),
    invoiceNumber: z.string()
})

// define gitaEntry schema
const GITAEntrySchema = ai.defineSchema(
    'GITAEntrySchema',
    z.object({
        tier: z.number().describe("The tier of this GITA entry if eligible for Green Investment Tax Allowance (GITA) Malaysia."),
        sector: z.string().describe("The sector (eg: energy efficiency, renewable energy system, waste, water) of this GITA entry."),
        technology: z.string().describe("The technology (eg: Transformer, Energy Efficient Appliances, Chiller, etc) of this GITA entry."),
        asset: z.string().describe("The asset (eg: Transformer, Thermal Energy Storage/Collector, Variable Air Volume) of this GITA entry."),
    })
);


// define carbonEntry schema
// scope 1: 𝐶𝑂2𝑒 𝑒𝑚𝑖𝑠𝑠𝑖𝑜𝑛𝑠 = ∑𝐴𝑐𝑡𝑖𝑣𝑖𝑡𝑦 𝐷𝑎𝑡𝑎 × 𝐸𝑚𝑖𝑠𝑠𝑖𝑜𝑛 𝐹𝑎𝑐𝑡𝑜𝑟 × 𝐺𝑊P, 
// scope 2: 𝐶𝑂2𝑒 𝑒𝑚𝑖𝑠𝑠𝑖𝑜𝑛𝑠 = 𝐸𝑙𝑒𝑐𝑡𝑟𝑖𝑐𝑖𝑡𝑦 𝑝𝑢𝑟𝑐ℎ𝑎𝑠𝑒𝑑 × 𝐺𝐸F
const CarbonEntrySchema = ai.defineSchema(
    'CarbonEntrySchema',
    z.object({
        scope: z.number().describe("Scope (eg: 1,2,3) according to Greenhouse Gas Protocol (GHG) of this carbon entry."),
        activityData: z.number().describe("The activity data of carbon emission of this carbon entry."),
        emissionFactor: z.number().describe("The activity data emission factor of carbon emission of this carbon entry if this entry is of scope 1."),
        gwp: z.number().describe("The Grid Emission Factor (GEP) of this carbon entry if this entry is of scope 2 (electricity)."),
        gef: z.number().describe("The activity data of carbon emission of this carbon entry."),
        co2eEmission: z.number().describe("The co2eEmission calculated using calculateScope1 or calculateScope2 for this carbon entry based on the entry respective scope."),
    })
);

// define flow for extractInvoice()
// output an array on item since a single  invoice can have multiple items
export const extractInvoice = ai.defineFlow(
    {
        name: 'extractInvoice', 
        inputSchema: z.object({
            file: z.string().describe("Local path to the invoice file"),
        }),
        outputSchema: InvoiceResponseSchema 
    },
    async (input) => {
        const { dataUrl } = await ai.run('load-invoice-file', async () => {
            const filePath = path.resolve(input.file);
            const fileExtension = path.extname(filePath).toLowerCase();
            
            let mimeType = fileExtension === '.pdf' ? 'application/pdf' : `image/${fileExtension.replace('.', '')}`;
            const b64Data = await readFile(filePath, { encoding: 'base64' });
            return { dataUrl: `data:${mimeType};base64,${b64Data}` };
        });

        const { output } = await ai.generate({
            model: googleAI.model('gemini-2.5-flash'),
            prompt: [
                { media: { url: dataUrl } },
                { text: "Extract all line items and total amounts from this invoice. Identify if assets are eligible for Green Investment Tax Incentive (GITA)." },
            ],
            output: {
                schema: InvoiceResponseSchema,
            }
        });

        // error handling
        if (!output) {
            throw new Error('Extraction failed.');
        }

        return output;
    }
);

// define flow for processInvoiceItems()


// define flow for convertToGitaEntry()


// define flow for convertToCarbonEntry()