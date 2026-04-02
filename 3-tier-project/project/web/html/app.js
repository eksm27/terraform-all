let API = "";

fetch("config.json")
.then(r=>r.json())
.then(c=>{
    API = c.app_endpoint;
    console.log("API:", API);
    checkHealth();
});

function checkHealth(){
fetch(API+"/health")
.then(r=>r.json())
.then(d=>{
    document.getElementById("health").innerHTML = d.status;
})
.catch(()=>document.getElementById("health").innerHTML="APP DOWN");
}

function register(){
console.log("Register clicked");

fetch(API+"/register",{
method:"POST",
headers:{"Content-Type":"application/json"},
body:JSON.stringify({
first_name:rfname.value,
last_name:rlname.value,
email:remail.value,
password:rpass.value,
mobile:"999",
location:"chennai",
dob:"2000-01-01"
})
})
.then(r=>r.json())
.then(d=>{
console.log(d);
alert(JSON.stringify(d));
})
.catch(e=>console.error(e));
}

function login(){
fetch(API+"/login",{
method:"POST",
headers:{"Content-Type":"application/json"},
body:JSON.stringify({
email:lemail.value,
password:lpass.value
})
})
.then(r=>r.json())
.then(d=>{
if(d.error){alert("Invalid");return;}
document.getElementById("profile").innerHTML="Welcome "+d.first_name;
});
}