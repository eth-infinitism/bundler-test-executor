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
const path = require('path')

dir=process.argv[2]

allFiles = fs.readFileSync(path.join(dir,'all.txt'), 'ascii').split('\n')


allFiles.sort()
allFiles.reverse()

allResults={}
allFiles.filter(f=>f.endsWith('.json')).forEach(f=>{
    const [_, filepath, name] = f.match(/^(?:\W*)(.*)\/(.*?).json/)
    json = JSON.parse(fs.readFileSync(path.join(dir,f), 'ascii'))
    res = removePrefix(json.testsuites.testsuite)
//    delete res.testcase
    d = allResults[filepath]
    if (!d) {
        d = allResults[filepath] = {}
    } 
    d[name] = res
	//console.log(name,res)
})


console.log(JSON.stringify(allResults,null,2))

