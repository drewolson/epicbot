exports.mockResponse = () => {
  return {
    body: "",
    headers: {},

    write: function (str) {
      this.body = this.body + str;
    },

    end: () => {},
    on: () => {},
    once: () => {},
    emit: () => {},

    setHeader: function (header, val) {
      this.headers[header] = val;
    },
  };
};

exports.readBufferedBody = (resp) => {
  return () => {
    return resp.body;
  };
};
