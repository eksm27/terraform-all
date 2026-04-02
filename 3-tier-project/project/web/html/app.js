let API = "";

// Load config
fetch("config.json")
    .then(res => res.json())
    .then(cfg => {
        API = cfg.app_endpoint;
        console.log("API:", API);
    });


// Register
async function register() {

    let file = document.getElementById("photo").files[0];

    let formData = new FormData();
    formData.append("file", file);

    let uploadRes = await fetch(API + "/upload", {
        method: "POST",
        body: formData
    });

    let uploadData = await uploadRes.json();

    let data = {
        first_name: fname.value,
        last_name: lname.value,
        email: email.value,
        password: password.value,
        mobile: mobile.value,
        location: location.value,
        dob: dob.value,
        photo_url: uploadData.url
    };

    await fetch(API + "/register", {
        method: "POST",
        headers: {"Content-Type":"application/json"},
        body: JSON.stringify(data)
    });

    alert("Registered Successfully!");
}


// Login
async function login() {

    let res = await fetch(API + "/login", {
        method: "POST",
        headers: {"Content-Type":"application/json"},
        body: JSON.stringify({
            email: login_email.value,
            password: login_password.value
        })
    });

    let data = await res.json();

    if (data.error) {
        alert("Invalid login");
        return;
    }

    let profile = document.getElementById("profile");

    profile.innerHTML = `
        <h2>Welcome ${data.first_name}</h2>
        <img src="${data.photo_url}" width="150">
        <p>Email: ${data.email}</p>
        <p>Mobile: ${data.mobile}</p>
        <p>Location: ${data.location}</p>
    `;

    profile.classList.remove("hidden");
}