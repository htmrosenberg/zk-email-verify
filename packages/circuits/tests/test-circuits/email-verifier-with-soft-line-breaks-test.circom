pragma circom 2.1.6;

include "../../email-verifier.circom";

component main { public [ pubkey ] } = EmailVerifier(640, 1408, 121, 17, 0, 0, 0, 1);
