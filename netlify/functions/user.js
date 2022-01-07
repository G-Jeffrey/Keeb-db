const { PrismaClient } = require('@prisma/client');
const {user} = new PrismaClient();
let bcrypt = require("bcrypt");
const salt = bcrypt.genSaltSync(8);
const capitalize = (str) =>{
    return str[0].toUpperCase() + str.slice(1).toLowerCase();
}
function getInfo(user){
	return JSON.stringify({
		'username':user.username,
		'first_name':user.first_name,
		'last_name':user.last_name,
		'email':user.email,
	});
}
const login = async (json)=>{
    let { user_identification, password } = json;
   const users = await user.findFirst({
		where: {
			OR: [{ email: user_identification }, { username: user_identification }],
		},
	});
	if(!users){
        return({
            statusCode: 203,
            body: "Username/email is not found"
        });
    }
	password = bcrypt.compareSync(password,users.password);
	if(password){
        let message = await getInfo(users);
        return({
            statusCode: 200,
            body: message
        });
	}else{
        return({
            statusCode: 400,
            body: "Incorrect Password"
        });
    }
}
const signup = async (json)=>{
    let {first_name, last_name, username, password, email, pfp} = json;
    if(!(first_name && last_name && username && password && email)){
        return {
            statusCode: 400,
            body: 'Missing Fields'
        }
    }
    let checkFor = [
		{ prop: "username", value: username },
		{ prop: "email", value: email },
	];
    const userExists = await function (item) {
		let res = user.findFirst({
			where: {
				[item.prop]: item.value,
			},
		});
		return res;
	};
    for (let field of checkFor) {
		if (await userExists(field)) {
            // check if username and email is unique
			return {
                statusCode: 203,
				body: `${field.value}: is already taken/used`
			};
		}
	}
    first_name = capitalize(first_name);
    last_name = capitalize(last_name);
    password = bcrypt.hashSync(password, salt);
    const createUser = await user.create({
        data:{
            username,
            password,
            first_name,
            last_name,
            email,
            pfp,
        }
    });
    // // login after sign-up => pushed the responsibility to the front end
    // login()
    return {
        statusCode: 200,
        body: JSON.stringify(createUser)
    }
}
exports.handler = async(event, context)=>{
    function findQuery(path){
        path = event.path.split('/');
        return path[path.length-1];
    };
    const path = findQuery(event.path);
    console.log(path);
    switch(path){
        case "login":
            if (event.httpMethod !== "GET") {
                return { statusCode: 405, body: "Method Not Allowed" };
            }
            return await login(JSON.parse(event.body));
        case "signup":
            if (event.httpMethod !== "POST") {
                return { statusCode: 405, body: "Method Not Allowed" };
            }
            return await signup(JSON.parse(event.body));
        default:
            return { statusCode: 400, body: "Invalid URL path" };
    };
};