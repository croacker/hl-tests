const BusinessNetworkConnection = require('composer-client').BusinessNetworkConnection;

const cardName = 'admin@accounting-stats';


const assetShop = 'com.croacker.accounting.Shop';

console.log("Create new BusinessNetworkConnection");
let bizNetworkConnection = new BusinessNetworkConnection();
let businessNetworkDefinition;
let isConnected = false;

/**
 * Подключиться к card
 * @returns {Promise<void>}
 */
async function connectToBizNetwork(){
    console.log("Connect to " + cardName);
    businessNetworkDefinition = await bizNetworkConnection.connect(cardName);
    console.log("successful connect");
}

/**
 * Отключится от card
 * @returns {Promise<void>}
 */
async function disconnectBizNetwork(){
    console.log("Disconnect from " + cardName);
    await bizNetworkConnection.connect(cardName);
    console.log("successful disconnect");
}

let getAssetRegistry = async function(assetName){
    if(!isConnected){
        await connectToBizNetwork();
        isConnected = true;
    }
    return bizNetworkConnection.getAssetRegistry(assetName);
};

async function connectToRopeStat(){
    console.log("getAssetRegistry " + assetShop);
    let assetsRegistry = await getAssetRegistry(assetShop);
    console.log("getAll " + assetShop);
    let assetsInfo = await assetsRegistry.getAll();
    let arrayLength = assetsInfo.length;
    console.log("Resource length " + arrayLength);
    for (let i = 0; i < arrayLength; i++) {
        console.log('for loop');
        console.log(assetsInfo[i]);
    }
    disconnectBizNetwork();
}

//connectToRopeStat();

async function runTestTrans() {

}