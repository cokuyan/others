var readline = require('readline');

var reader = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

var addNumbers = function (sum, numsLeft, completionCallback) {
  if (numsLeft == 0) {
    reader.close();
    return completionCallback(sum);
  }

  reader.question("Enter number", function (input) {
    var num = parseInt(input);
    sum += num;
    numsLeft--;
    completionCallback(sum);
    addNumbers(sum, numsLeft, completionCallback);
  });

};

addNumbers(0, 3, function (sum) {
  console.log("Total Sum: " + sum);
});
