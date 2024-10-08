const knex = require('knex')({
    client: 'sqlite3',
    connection: {
      filename: 'data/rates.sqlite',
    },
    useNullAsDefault: true,
  });

function insertData(results) {
    const inserts = [];
    for (let i = 0; i < results.length; i++) {
        inserts.push(knex('rates').insert({
             country: results[i].country,
             type: results[i].type,
             rate: results[i].rate,
             situationOn: results[i].situationOn
         }).then(() => {
             console.log('Data inserted!');
         }));
     }
    return inserts;
}

knex.schema.hasTable('rates').then((exists) => {
    if (!exists) {
        return knex.schema.createTable('rates', (table) => {
            table.string('country');
            table.string('type');
            table.float('rate');
            table.date('situationOn');
            table.string('description');
        }).then(() => {
            console.log('Table created!');
        });
    } else {
        console.log('Table already exists!');
        return Promise.resolve();
    }
}).then(() => {
    console.log("Inserting data...");
    // read data from data/vatrates.csv
    const fs = require('fs');
    const csv = require('csv-parser');
    const results = [];
    const inserts = [];
    fs.createReadStream('data/vatrates.csv')
        .pipe(csv())
        .on('data', (data) => results.push(data))
        .on('end', () => {
            Promise.all(insertData(results)).then(() => {
                console.log('All data inserted!');
                knex.destroy();
            });   
        });
})
.catch((error) => {
    console.error(error);
});
