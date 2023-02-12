#!/usr/bin/env node
// create a full history json file

//recursively remove "@" prefix from property names
function removePrefix(obj) {
    return Object.keys(obj).reduce((set,key)=>{
        val = obj[key]
        key = key.replace(/@/,'')
        return {
            ...set,
            [key]: typeof val == 'object' && val != null ? removePrefix(val) : val
        }
    }, {})
}

const fs = require('fs')

dir=process.argv[2]

allFiles = fs.readFileSync(dir+'/all.txt', 'ascii')

console.log('all=',allFiles)
allResults={}
allFiles.split('\n').filter(f=>f.endsWith('.json')).forEach(f=>{
    const [_, path, name] = f.match(/(.*)\/(.*?).json/)
    json = JSON.parse(fs.readFileSync(dir+f, 'ascii'))
    res = removePrefix(json.testsuites.testsuite)
    delete res.testcase
    d = allResults[path]
    if (!d) {
        d = allResults[path] = {}
    } 
    d[name] = res
	console.log(name,res)
})


console.log(JSON.stringify(allResults,null,2))

