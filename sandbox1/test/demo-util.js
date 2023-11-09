import { toEpoch } from '../src/util.js';
import assert from 'assert';

describe('util', function () {
  describe('toEpoch()', function () {
    it('Convert today to Unix Time', function () {
      var today = new Date();
      assert(toEpoch(today) === today.valueOf());
    });
  });
});