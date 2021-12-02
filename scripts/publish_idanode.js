const { hashElement } = require('folder-hash')
const CryptoJS = require('crypto-js')
const fs = require('fs')
let pkg = require('../package.json')
const BdcashCore = require('@bdcash-protocol/core')
const bdcash = new BdcashCore
bdcash.staticnodes = true
bdcash.debug = true
require('dotenv').config()

let version = pkg.version
const options = {
    folders: { exclude: ['.*', 'node_modules', 'test_coverage'] },
    files: { include: ['*.js', '*.json'] }
}

hashElement('./dist', options).then(async hash => {
    let checksum_hash = CryptoJS.SHA256(hash.hash).toString(CryptoJS.enc.Hex)
    const data = fs.readFileSync('./checksum', 'utf8')
    let checksums = data.split("\n")
    let found = false
    for (let x in checksums) {
        let checksum = checksums[x].split(':')
        if (checksum[0] === version) {
            found = true
        }
    }
    if (!found) {
        if (process.env.PUBLISHER_KEY !== undefined) {
            console.log('WRITING CHECKSUM INTO THE BLOCKCHAIN')
            let privkey = process.env.PUBLISHER_KEY
            let pubkey = await bdcash.getPublicKey(privkey)
            let address = await bdcash.getAddressFromPubKey(pubkey)
            console.log('ADDRESS IS ' + address)
            let balance = await bdcash.get('/balance/' + address)
            if (balance.balance > 0.001) {
                let sid = await bdcash.importPrivateKey(privkey, 'TEMP', false)
                let result = await bdcash.write(sid.walletstore, 'TEMP', checksum_hash, '', version, '')
                if (result.uuid !== undefined) {
                    console.log('WRITTEN CHECKSUM ON THE BLOCKCHAIN')
                    fs.appendFileSync('./checksum', "\n" + version + ':' + checksum_hash)
                    console.log('APPENDING CHECKSUM IN LOCAL FILE')
                }else{
                    console.log('ERROR WRITING CHECKSUM')
                }
            } else {
                console.log('NOT ENOUGH BALANCE')
            }
        } else {
            console.log('APPENDING CHECKSUM IN LOCAL FILE')
            fs.appendFileSync('./checksum', "\n" + version + ':' + checksum_hash)
        }
    }else{
        console.log('CHECKSUM ALREADY WRITTEN')
    }
}).catch(error => {
    console.log(error)
})