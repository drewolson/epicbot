const cheerio = require("cheerio");

exports.parseCards = function (doc) {
  var $ = cheerio.load(doc);

  return $("tr").map(function (i, elem) {
    var id = i.toString();
    var name = $(this).find("td.column-2").text()

    if (name === "") {
      return null;
    }

    var urls = $(this).find("img").map(function (j, nested) {
      var src = $(this).attr("src");

      if (src.endsWith("epic_back.jpg")) {
        return null;
      }

      return src;
    }).get();

    return {
      id: id,
      name: name,
      urls: urls
    };
  }).get();
};
