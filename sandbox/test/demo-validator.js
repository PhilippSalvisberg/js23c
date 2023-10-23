import assert from 'assert';
import validator from 'validator';

describe('Validator', function () {
  describe('isEmail()', function () {
    it('philipp@salvis.com is valid', function () {
      assert(validator.isEmail('philipp@salvis.com'));
    });
    it('Philipp Salvisberg <philipp@salvis.com> is invalid with default options', function () {
      assert(validator.isEmail('Philipp Salvisberg <philipp@salvis.com>') === false);
    });
    it('Philipp Salvisberg <philipp@salvis.com> is valid when allowing display name', function () {
      assert(validator.isEmail('Philipp Salvisberg <philipp@salvis.com>', {allow_display_name: true}));
    });
  });
});