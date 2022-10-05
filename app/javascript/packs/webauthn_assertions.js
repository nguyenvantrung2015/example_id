import {get, parseRequestOptionsFromJSON} from "@github/webauthn-json/browser-ponyfill";
import axios from "axios";
document.addEventListener('turbolinks:load', () => {
    const loginByWebauthButton = document.getElementById("webauthn-login");
    loginByWebauthButton.addEventListener('click', handleLogin);

    async function handleLogin(){
      try {
          const email = document.getElementById("email").value;
          const response = await axios.post("/webauthn/assertions/options", {email});

          if (response) {
              const options = parseRequestOptionsFromJSON(response.data);
              const authnResponse = await get(options);
              const result = await axios.post("/webauthn/assertions", {authnResponse});
              if (result.status === 200) {
                  window.location.href = "/";
              }
          }
      }catch {
          window.location.href = "/webauthn";
      }
    }
});