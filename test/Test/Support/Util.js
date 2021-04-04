exports.mockResponse = function () {
  return {
    body: "",
    headers: {},

    write: function (str) {
      this.body = this.body + str;
    },

    end: function () {},
    on: function () {},
    once: function () {},
    emit: function () {},

    setHeader: function (header, val) {
      this.headers[header] = val;
    },
  };
};
