import assert from 'assert';
import validator from 'validator';

describe('Validator', function () {
  describe('isEmail()', function () {
    it('should accept "philipp@salvis.com" as valid e-mail address', function () {
      assert(validator.isEmail('philipp@salvis.com'));
    });
    it('should not accept "Philipp Salvisberg <philipp@salvis.com>" as valid e-mail address with default options', function () {
      assert(validator.isEmail('Philipp Salvisberg <philipp@salvis.com>') === false);
    });
    it('should accept "Philipp Salvisberg <philipp@salvis.com>" as valid e-mail address when allowing display_name', function () {
      assert(validator.isEmail('Philipp Salvisberg <philipp@salvis.com>', {allow_display_name: true}));
    });
  });
});