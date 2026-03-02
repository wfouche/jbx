import std/[httpclient, json]
import osproc
import strutils
import std/cmdline

# 1. Initialize the client
let client: HttpClient = newHttpClient()

let parts: seq[string] = split(paramStr(1), '@')
try:
  let alias: string = parts[0]
  let baseUrl: string = "https://raw.githubusercontent.com/" & parts[1] & "/jbang-catalog/refs/heads/main"

  # 2. Retrieve the content
  let url: string = baseUrl & "/" & "jbang-catalog.json"
  let response: string = client.getContent(url)

  # 3. Parse the JSON string
  let data: JsonNode = parseJson(response)

  # 4. Access fields
  let scriptRef: string = data["aliases"][alias]["script-ref"].getStr()
  let scriptUrl: string = baseUrl & "/" & scriptRef
  let scriptText: string = client.getContent(scriptUrl)
  let filename: string = scriptRef
  writeFile(filename, scriptText)

  discard execCmd("java " & filename & " " & paramStr(2))
finally:
  client.close()