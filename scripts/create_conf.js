const BdcashCore = require('@bdcash-protocol/core')
const bdcash = new BdcashCore
const fs = require('fs')
const homedir = require('os').homedir();
const bdcashconf = homedir + '/.bdcash/bdcash.conf'
console.log('CONFIG PATH IS ' + bdcashconf)
const nodeshconf = './.env'

async function create() {
    let rpcuser = await bdcash.createAddress('-')
    let nodeshkey = await bdcash.createAddress('-')

    let bdcashconfcontent = `rpcuser=` + rpcuser.pub + `\nrpcpassword=` + rpcuser.prv + `\nrpcallowip=127.0.0.1\nstaking=0\nlisten=1\nserver=1\ndaemon=1\nindex=1\ntxindex=1\nlogtimestamps=1`
    let nodeshconfcontent = `RPCUSER=` + rpcuser.pub + `\nRPCPASSWORD=` + rpcuser.prv + `\nRPCPORT=36264\nRPCPORT_TESTNET=37264\nRPCADDRESS=localhost\nDEBUG=true\nDB_PORT=27017\nDB_HOST=localhost\nCOIN=BDCASH\nAIRDROP=0\nSERVERMODE=true\nTESTNET=false\nP2PPORT=36263\nNODE_KEY=` + nodeshkey.prv + `\nADMIN_PUBKEY=` + nodeshkey.key + `\nSYNC=true\nMAX_OPRETURN=7500`

    try {
        fs.writeFileSync(bdcashconf, bdcashconfcontent)
        console.log('WROTED CONFIG FILE')
        let checkbdcashconf = fs.readFileSync(bdcashconf, { encoding: 'utf8' })
        if (checkbdcashconf === bdcashconfcontent) {
            console.log('CONFIG FILE VERIFIED, CREATING NODESH CONFIG FILE')
            fs.writeFileSync(nodeshconf, nodeshconfcontent)
            console.log('CONFIGURATIONS FILE WROTED CORRECTLY!')
        }else{
            console.log('CAN\'T VERIFY CONFIG FILE, STOPPING.')
        }
    } catch (e) {
        console.log(e)
    }
}

create()