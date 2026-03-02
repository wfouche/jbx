import std/[httpclient, json]
import osproc
import strutils
import std/cmdline

# 1. Initialize the client
let client = newHttpClient()

let parts: seq[string] = split(paramStr(1), '@')
try:
  let alias = parts[0]
  let baseUrl = "https://raw.githubusercontent.com/" & parts[1] & "/jbang-catalog/refs/heads/main"

  # 2. Retrieve the content
  let url = baseUrl & "/" & "jbang-catalog.json"
  let response = client.getContent(url)

  # 3. Parse the JSON string
  let data = parseJson(response)

  # 4. Access fields
  let scriptRef = data["aliases"][alias]["script-ref"].getStr()
  let scriptUrl = baseUrl & "/" & scriptRef
  let scriptText = client.getContent(scriptUrl)
  let filename = scriptRef
  writeFile(filename, scriptText)

  discard execCmd("java " & filename & " " & paramStr(2))

finally:
  client.close()