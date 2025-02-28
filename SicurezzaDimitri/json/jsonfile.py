import json

def JsonSerialize(data):
    with open("data_file.json", "w") as write_file:
        json.dump(data, write_file)

def JsonDeserialize(sFile):
    with open(sFile, "r") as read_file:
        return json.load(read_file)
    
def print_dictionary(dData, sRott):
    for keys, values in dData.items():
     if sRoot != "":
         print("Trovata chiave" + sRoot + "." + keys)
         else:


sFilePath = "json/example_2.json"
dData = JsonDeserialize(sFilePath)
print_dictionary(dData)
sys.exit()


print(type(data[quiz]))
if (type(data[quiz])) is dict:


    schema = {
    "type": "object",
    "properties": {
        "name": {"type": "string"},
        "age": {"type": "number"},
        "scores": {
            "type": "array",
            "items": {"type": "number"},
        }
    },

}