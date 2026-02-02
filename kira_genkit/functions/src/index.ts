import 'dotenv/config'; // additional installation
import {genkit, z} from "genkit";
import {googleAI} from "@genkit-ai/google-genai";

/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {setGlobalOptions} from "firebase-functions";
import {onRequest} from "firebase-functions/https";
import * as logger from "firebase-functions/logger";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({ maxInstances: 10 });

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const ai = genkit({
  plugins: [
    googleAI({ apiKey: process.env.GOOGLE_GENAI_API_KEY})
  ],
});

// define item schema
const ItemSchema = ai.defineSchema(
    'ItemSchema',
    z.object({
        // think about what attributes does an ItemSchema have, how are each described
        name: z.string().describe("The name of item purchase in this invoice (eg: petrol, solar panel, diesal, biodegradable container)."),
        supplier: z.string().describe("The supplier of this invoice."),
        quantity: z.number().describe("The amount purchased for this item."),
        unit: z.string().describe("The unit (eg: single, kg, litres) purchased for this item."),
        price: z.string().describe("The price of item purchased."),
        dateOfPurchase: z.date().describe("The date of this invoice issued.")
    })
);

// define gitaEntry schema
const GITAEntrySchema = ai.defineSchema(
    'GITAEntrySchema',
    z.object({
        // think about what attributes does an GITAEntrySchema have, how are each described
        isEligible: z.boolean().describe("Is this item eligible for Green Investment Tax Allowance (GITA) Malaysia?"),
        tier: z.number().describe("The tier of this GITA entry if eligible for Green Investment Tax Allowance (GITA) Malaysia."),
        sector: z.string().describe("The sector (eg: energy efficiency, renewable energy system, waste, water) of this GITA entry."),
        technology: z.string().describe("The technology (eg: Transformer, Energy Efficient Appliances, Chiller, etc) of this GITA entry."),
        asset: z.string().describe("The asset (eg: Transformer, Thermal Energy Storage/Collector, Variable Air Volume) of this GITA entry."),
    })
);


// define carbonEntry schema
const CarbonEntrySchema = ai.defineSchema(
    'CarbonEntrySchema',
    z.object({
        // think about what attributes does an CarbonEntrySchema have, how are each described
        scope: z.number().describe("Scope (eg: 1,2,3) according to Greenhouse Gas Protocol (GHG) of this carbon entry."),
        activityData: z.number().describe("The activity data of carbon emission of this carbon entry."),
        emissionFactor: z.number().describe("The activity data emission factor of carbon emission of this carbon entry if this entry is of scope 1."),
        gwp: z.number().describe("The Grid Emission Factor (GEP) of this carbon entry if this entry is of scope 2 (electricity)."),
        gef: z.number().describe("The activity data of carbon emission of this carbon entry."),
        co2eEmission: z.number().describe("The co2eEmission calculated using calculateScope1 or calculateScope2 for this carbon entry based on the entry respective scope."),
    })
);

// define flow for extractInvoice()

// define flow for determineIsGitaEntry()

// define flow for determineIsCarbonEntry()