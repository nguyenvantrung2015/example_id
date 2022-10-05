import {create, parseCreationOptionsFromJSON} from "@github/webauthn-json/browser-ponyfill";
import axios from "axios";
document.addEventListener('turbolinks:load', () => {
    const clickButton = document.getElementById("webauthn-register");
    clickButton.addEventListener('click', handleClick);


    async function handleClick() {
        try {
            const response = await axios.post("/webauthn/credentials/options", {});
            const options = parseCreationOptionsFromJSON({publicKey: response.data});
            const webauthCredential = await create(options);
            const result = await axios.post("/webauthn/credentials", {
                webauthCredential
            });
            if (result.status === 200) {
                window.location.href = "/webauthn/credentials";
            }
        }catch {
            window.location.href = "/webauthn/credentials";
        }
    }
});