
# creazione environment, per evitare che ubuntu non vi faccia installare la libreria di crittografia
# python -m venv .venv
# e poi:
# . .venv/bin/activate
# e poi fare pip install pycryptodome
#

from Crypto.PublicKey import RSA
from Crypto.Cipher import PKCS1_OAEP
import base64


# # Per importare una chiave pubblica
# keyDER = base64.b64decode(pubkey)
# seq = base64.asn1.DerSequence()
# seq.decode(keyDER)
# keyPub = RSA.construct((seq[0], seq[1]))

# # Per iniziare generiamo una coppia di chiavi e le stampiamo
# # Generating RSA Key Pair
# # Una volta stampate, non serve più
# key_pair = RSA.generate(2048)
# print(key_pair.export_key())
# public_key = key_pair.publickey()
# print(public_key.export_key())
# exit(0)
# sPriv = "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEA3AqNkw+4Pnd0fKkYQRKkr8BDrUDVxD75cHizbkfKE4CnWGEW\nfP7Yi25nBp10qCyOdBfr1LD7DGXJpGJA4L1teUOzbT2ztEZGPuur532z/bQdcIte\nIIipO4fGzsCiSkeXVu+W/rLWHGuHgss2ULxeAx8mzbSc1UqdV4z1wmERprqNLLZZ\nIRAewYkdBIhQ57IvxX+DXeQTPkPPO4jZTmWVcf7/JpmDrDiOWbl/fg/UPNxzxvO3\nC2MA3FEr1ZmvUgqKX1M3XZS6FKvJCvnNQdYxPVRe3Ra6KOdA6vdfCOCoGFH8CjwA\nI9Aquz8AM951Sk3tQp8TGXeQOx2H2vemohmAbQIDAQABAoIBABi3zsOQZoAN5zYB\nwMm+kGV10aRqvhi3gknSJUXkJp0ePK4+6cnMzwKKumQR2AL0TmRYM5PG9cykuowO\nxX75iIywwD0rSz6bDlUPIFZ21ntPemckIMTC1U/sprafCRwTArsvWuTtrgOvSJ+2\nuDlFj8IGA9Pj0CJdqWMmYI0fXl4+LT7QleYdoPON0wOMwKRztv7JiLb0zdgAFKhR\n/hpQAL++6FFnH6izSwvd+TDb8jLk2EE3+9XY/SObm+Fftgm2sef11nuTr8GYDycu\nvsfDFxnWmpn7xvMnalGk3+kchoReUHYxoEBo5Ryj5kK5ZETMeWThNxqvqUuHBq3/\nb4x+PLkCgYEA7HoLoF9QWQOOK9IOHWxLl+R7n1ZJwQBqcPm8sNJoQkH1oL3ResPD\nZM12/DDNg5QtgFoe7mDYJnqr8Nc4lm6fgEtM/yGVJ1nAg6TEJEmSp1C5Ksvu8S1H\nKLdZ/OM51lUGuY7nN+rA7h41KnM8Tc6cGBo2X0kUCJsGmf4NSqLAyj8CgYEA7jUk\nQ4wBmH7xvgho8moSQLhP7BR8UahB8Wcw2LQ/tGwRJ9/LZ9hKMQS/hThbCWoOMHwN\ntKSIYnZ7uqWDZ20YJ0PPv967F93oQS7sf6RBoYmm8QEB62A/BrVqj33kCHb5Bu60\nmfktFroS2DwFSvH3lLX77rkiOfhm+EJhKQXAklMCgYACR8sE6OZldVtRoNzx+7Fe\n7Z0jlDlx2wcrv7zKF71ZpjkwK6RxgqHHvxN+qxnQQwWNT1EtC1IKTPSLhgfNq5Nu\nMUu0yiYeEweAPX6Guw7m/ihK+Vx8hutAwUPk5GwSXQ+Lio1ARMtHgJMSrbnPJkbr\nFJWhpZrD2nrd0U1fguJJEQKBgQDl34qbVKTFkNug02TTauEqa7NU04AVHRZl63sL\n5QYFCrSTkjgsgmE2ZKqd2QChWSNQTqa7SHwE6OoF+GuSh4jje2Eke8B5C8ByBuJb\nWxuq07eyo5JCnqKzyqaGyqogMQ+oTPskC34jjHVbDrDc3hxZ+jSg7y/EWZ6kvQoe\nGFr52QKBgDHKMyQ8W2vccZeFJWKThjrM6fatKRgnit2VEUN7qpxyNoFjrHbt4Mzy\nB6JDQ+cMPJ28FhqR4FcjPbqS5osLWIpZe/QXalnFVEDEjePJe2iySZH6rXaOfhb2\nRulv2YiLx0w1W5L44MfJQ4PSsZuTRVC0lQEcWmsdrov6N7hmUUS3\n-----END RSA PRIVATE KEY-----"

sPub = "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA3yJXJgUFG1GL/ua9d9Lx\nPDdcdMFNnabQ97Muw8qV8ub7ZeNNGVoAgobHM/2LhKNt07bIek5LivtTXF24mmCh\nrtDsShl9yBo2QGIA67vAtgUSuhLbQ6LEJYMxeQL9rTMkrJUlbRwrmW1e/63QuQVB\nUcTTdS4POd45FATy3dxmZCLMtyKRTfOCtNOmel+0V1TEZ4J12zvnX6K2rxl344pF\nNhrHFDdQRyA/kMGa/CPPfOf/Ua4VbXL9ZbvscVsWfvSXikpE7XlqPKrt8EXNQs/T\nCZEGp03PcSOhlYX2eptv2zsBAUX0BLgvKOartos44OxtSSP4pj6orLldZfhOG4xl\nuQIDAQAB\n-----END PUBLIC KEY-----"
sPriv = "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEAoTpg02bpVeKrVhx8xUk/zj91lfggZrqtLgsADvWToXABjU37\nCO0XzNtHH4bhfKKMUhTc3xpmzolLgGe0FwSjMNZx6O6xTarjK8kxk544C6VyeCB6\nkf57I3VeIbVPMfuBuOuvFrUOGMG80gI3RAQDF8cxM7pso4E+zg3VD/Mhst8k+QUG\nzCavQfjN9b+TxKnJ96c14YQ3pG3YPXb8t/LdoGcTp3DmXKQDt/juxq+RuR9UAIwa\nMam6ZG9VeuyMi74n39drtgxqEjBhARO7xUYWc6kOOvJ0ulBJ28Lc6Kc5s5EwLeRX\np4+pYBJPr43kWPPQnaZmTm9tTb08DKO5kyhpJwIDAQABAoIBABtuwnDV7tfVNI/3\nUueCmh+uvoQg7upr0vGln4HsGQ178FepsBAJv2X03Xooyg8Z3UROFnLDnECCLd2Q\nR50vBdFWe5VFn9d2PycBGbVjU2fv47U62YAjy7Hx021q2ynHAICFYYo8jkR6GnWl\nOOASyq/uDZoem0OKxzPqOJl5Jf+4II4BabqV3NGqyV2uFRAihD+iivPr3jHk9d+B\nx11wAviLMs9QW9xWUiCtZ84R6obl4pYpFyi+oAVrV0eXbKIBDI2buRHx51mfCgdA\nFcSaNE9q2haTq43HVFWEjB14sj2y9Lef11issuw8NeiPAQ6CUY543BuFbf/uv90H\nedXHDoECgYEAtVNTNI30XjJd/UYW6j5jppyVCKEdktAQRVOiW/t+4Py4InNCQzKD\nYBExiI2sZhLNEy44+k+6PeBdjqfFzZygWUg3Mv+hO8CQLOFbxAQxmPYcIomiNETe\nC2Uybbznr+1GxFRd1tZrXLKb3sIp2zhgaHi4Zf7VJUJ89lFivhYCKEECgYEA46A7\nQF7aAzMbMXbxfVOAX2jIDmLLp5EkZFJdTBwKMF9+1oPu1ZA9GJMRrdEFXFjUev67\nadsNnLOPdBB0c7z2H54SE1hikKg2ffLnH0tarGymZFkMEJT4PqxbRd6pNQGQCsWP\n/D9/c0szflb/ZgB49UrSttxjoWL0bNsz9/KUd2cCgYBG3BA5CnyDzzURxDEySz1Q\nIALRw3y2Id8p6HwbbBXyQHCI7ffoILZcdXug/JRxs0k3BKo5j6ydf6+wDvpq1pmH\nKoR/xowwuJjfIRZmbKkhOJRYHucne/41/88MOXVlN9me4cVmLpb4O8hT7hbDV629\nRefx2/tZuzjwXW+0Dw+6wQKBgQC/H0OAyeN9ukSD5N3hH+JyubT4N0XOHZUT0wBZ\nLlXzxcrm7QH1OVXDM4Etk4pPvpox536O5Alq4G17w3Ez2J5Db+K3cYfY9BRE7lXX\nNdsdWWDgctApgBtr7CX65Xjnc7dxA+7gmqQ1txe2Ze+twonNU5TXSvcwg7i9SdQ5\nxOmZ0wKBgD6/0jWPZ+4XGkbRna0TImuMwZ+k0fjOZLVuW9LhCvGMkyXQmB9qeGEO\njdloJBIp0VSPzfNbkoZf76cjbp5JXTASdu1jwQ2Eg3SspXQkCVXrp3a9WJ/M9m7h\nT+gKjz9rzzqpR5AuPG+WWzCFVs7CMt3r2Et0v4Gh/wHTgBA/xNxe\n-----END RSA PRIVATE KEY-----"
#sPub = "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoTpg02bpVeKrVhx8xUk/\nzj91lfggZrqtLgsADvWToXABjU37CO0XzNtHH4bhfKKMUhTc3xpmzolLgGe0FwSj\nMNZx6O6xTarjK8kxk544C6VyeCB6kf57I3VeIbVPMfuBuOuvFrUOGMG80gI3RAQD\nF8cxM7pso4E+zg3VD/Mhst8k+QUGzCavQfjN9b+TxKnJ96c14YQ3pG3YPXb8t/Ld\noGcTp3DmXKQDt/juxq+RuR9UAIwaMam6ZG9VeuyMi74n39drtgxqEjBhARO7xUYW\nc6kOOvJ0ulBJ28Lc6Kc5s5EwLeRXp4+pYBJPr43kWPPQnaZmTm9tTb08DKO5kyhp\nJwIDAQAB\n-----END PUBLIC KEY-----"

# Ora dobbiamo ricreare le chiavi a partire da queste due stringhe
key_pair = RSA.import_key(sPriv)
public_key = RSA.import_key(sPub)


# Function to encrypt message
def encrypt_message(message, pub_key):
    cipher = PKCS1_OAEP.new(pub_key)
    encrypted_message = cipher.encrypt(message.encode("utf-8"))
    return base64.b64encode(encrypted_message).decode("utf-8")


# Function to decrypt message
def decrypt_message(encrypted_message, priv_key):
    cipher = PKCS1_OAEP.new(priv_key)
    decrypted_message = cipher.decrypt(base64.b64decode(encrypted_message))
    return decrypted_message.decode("utf-8")


# decripto messaggio ricevuto
# encrypted_message = "H5UIPSCLCwpKCutRPzeVYt+7WKrW2Y0qq1OpQGeZIjHx7lW6kuraQZKMUhbl09teYMv1aAmqxdjqQGRmpj5GVXYwpDly+I+anzhE85Thvk7JVa8nHIXVBpUYuDVaroXlCw3aofgcMnAS0Wpjo+2OPe9b0CidJ/YIiRdxYsdQ8fECvVFVkkn2F4DXqOXRq1LfWJ7kFfTAXcxoAdzGs54jWPVgvbKmOu+z51Fczff9hw0rmZWtO6KQl5NSl+YVeX0BgFBjDr9bEg+Lr2MX7O+JgnSkzqOSaCr1qNJh3D3UYsPNDhBbFnQTy5kizXN2JRCnAaYJdLBVm3UhDHQu/e5RdQ=="
# decrypted_message = decrypt_message(encrypted_message, key_pair)
# print("Decrypted Message:", decrypted_message)

# invio messaggio criptato
# message = "La version de la version"
# encrypted_message = encrypt_message(message, public_key)
# print("Encrypted Message:", encrypted_message)
