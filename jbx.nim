import std/[httpclient, json]
import osproc

# 1. Initialize the client
let client = newHttpClient()

try:
  let alias = "hello"
  let baseUrl = "https://raw.githubusercontent.com/jbangdev/jbang-catalog/refs/heads/main"

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

  discard execCmd("java " & filename & " John")

finally:
  client.close()