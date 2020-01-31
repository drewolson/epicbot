const elasticlunr = require("elasticlunr");

exports._addDoc = function (doc, index) {
  index.addDoc(doc);

  return index;
};

exports._newDocIndex = elasticlunr(function () {
  this.addField("name");
  this.setRef("id");
});

exports._searchDoc = function (term, index) {
  return index.search(term, {});
};
