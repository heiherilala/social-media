import { faker } from '@faker-js/faker';
import fs from 'fs';

const josnoTooSql = (tabelNam, data)=>{
    const longeur = data.length;
    let value = [];
    let stringValue = "insert into " + tabelNam + " (";
    for (const key in data[0]) {
        stringValue=stringValue+key+",";
    }
    stringValue=stringValue.replace(/.$/,") values ");
    stringValue=stringValue+"\n";
    for (let i = 0; i < longeur; i++) {
        value[i] = "(";

        for (const key in data[i]) {
            if (typeof(data[i][key])=="string") {
                value[i]=value[i]+"'"+data[i][key]+"'"+",";
            }else{
                value[i]=value[i]+data[i][key]+",";
            }
        }
        value[i]=value[i].replace(/.$/,"),");
        if (i==longeur-1) {
            value[i]=value[i].replace(/.$/,";");
        }
    }
    for (let i = 0; i < data.length; i++) {
        stringValue = stringValue+value[i]+"\n"
    }
    return stringValue;
};

const data = [];

for (let i = 0; i < 100000; i++) {
    let first_name = faker.name.firstName().replace("'","''");
    let last_name = faker.name.lastName().replace("'","''");
    let nickname = first_name.slice(0,first_name.length-2);
    let date = faker.date.birthdate({min:1982, max:2010, mod: 'year', refDate: "Date"});
    let birthday = ""+
    date.getFullYear().toString()
    +"-"
    +
    ((date.getMonth()+1)<10?("0"+(date.getMonth()+1)):(date.getMonth()+1))
    +
    "-"+
    ((date.getDate()+1)<10?("0"+(date.getDate()+1)):(date.getDate()+1))
    ;
    let gender= Math.random()<0.5?"F":"M";
    let email = faker.internet.email();
    let profile_pic = first_name+last_name+".png";
    data[i]={
        first_name:first_name,
        last_name:last_name,
        nickname:nickname,
        birthday:birthday,
        gender:gender,
        email:email,
        profile_pic:profile_pic
    };
}

const dataText = josnoTooSql("account",data)



fs.writeFile('ecrir.sql',dataText, (err)=>{
    if (err) {
        console.log(err);
    }
}
)


//console.log(dataText);