# The App
The application is located at https://double-blind.xyz.

The documentation for the app is located at https://double-blind.xyz/docs

# Development Instructions.

(this section is under construction)

```
circuits/
    inputs/ # Test inputs for example witness generation for compilation
    scripts/ # Run snarkjs ceremony to generate zkey with yarn compile
```
# Getting email headers

In outlook, turn on plain text mode. Send an email to yourself, and copy paste the full email details into the textbox on the (only client side!) webpage.

Notes about email providers: tl;dr: view headers in a non-gmail client.

Gmail self-emails censor the signature of the mailserver, so it is unclear if it is generated. .edu domain, hotmail, custom domain, and outlook domain self-emails have the signatures. In fact, Gmail-sent self-emails using the .edu domain, viewed in a non-gmail client, are not censored -- it seems to be just a property of the gmail viewer to not show signatures on self emails (but it has signatures on every other recieved email).



## CIRCOM BUILD STEPS

```
wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_20.ptau
# shasum pot21_final.ptau: e0ef07ede5c01b1f7ddabb14b60c0b740b357f70
mv powersOfTau28_hez_final_20.ptau powersoftau/powersOfTau28_hez_final_20.ptau
yarn compile-all
```
If you want bespoke compiling instead of compile-all, you can use the following:

    If you want to generate a new email/set of inputs, edit the src/constants.ts file with your constants.
    In generate_input.ts, change the circuitType to match what circom file you are running, then run
    ```
    ts-node circuits/scripts/generate_input.ts
    ```
    which will autowrite input_<circuitName>.json to the inputs folder.

    To do the steps in https://github.com/iden3/snarkjs#7-prepare-phase-2 automatically, do
    ```
    yarn compile email true
    ```
    and you can swap `email` for `sha` or `rsa` or any other circuit name that matches your generate_input type.

    and when the circuit doesn't change,
    ```
    yarn compile email true skip-r1cswasm
    ```

    and when the zkey also doesn't change,
    ```
    yarn compile email true skip-r1cswasm skip-zkey
    ```

For production, make sure to set a beacon in .env.

Double blind circuit:
```
circom circuits/main/rsa_group_sig_verify.circom --wasm --r1cs
snarkjs zkey new ./rsa_group_sig_verify.r1cs pot21_final.ptau public/rsa_group_sig_verify_0000.zkey
snarkjs zkey export verificationkey public/rsa_group_sig_verify_0000.zkey public/rsa_group_sig_verify_0000.vkey.json
cp rsa_group_sig_verify_js/rsa_group_sig_verify.wasm public
```
## Stats
Just RSA + SHA (without masking or regex proofs) for arbitrary message length <= 512 bytes is 402802 constraints, and the zkey took 42 minutes to generate.