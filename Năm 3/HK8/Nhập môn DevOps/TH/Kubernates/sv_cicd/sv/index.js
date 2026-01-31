const express = require('express')
const app = express()
const port = 3000

app.get('/', (req, res) => {
    var newData = "<p>PodName: " + process.env.MY_POD_NAME + "</p>";
    newData += "<p>PodIP: " + process.env.MY_POD_IP + "</p>";
    newData += "<p>Namespace: " + process.env.MY_POD_NAMESPACE + "</p>";
    newData += "<p>NodeName: " + process.env.MY_NODE_NAME + "</p>";
    res.send(newData)
})

app.get('/about', (req, res) => {
    res.send('<h1>HCMUS</h1>')
})


app.get('/contact', (req, res) => {
    res.send("<h1>FIT-HCMS</h1>");
})

app.get('/hello', (req, res) => {
    res.send("Quan Nguyen");
})


app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})

module.exports = app