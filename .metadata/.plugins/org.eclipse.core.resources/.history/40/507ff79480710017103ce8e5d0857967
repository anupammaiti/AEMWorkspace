/*******************************************************************************
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2013 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 ******************************************************************************/
var luhn = {
    validate: function(ccNumber) {
        var result = false;
        if (typeof ccNumber === 'number') {
            var checkDigit = ccNumber % 10,
                ccN = ccNumber,
                i = 0,
                sum = 0,
                digit;
            ccN = Math.floor(ccN / 10);
            while (ccN !== 0) {
                digit = ccN % 10;
                if (i % 2 === 0) {
                    digit *= 2;
                }
                sum += this.sumOfDigits(digit);
                ccN = Math.floor(ccN / 10);
                i++;
            }
            if ((sum * 9) % 10 === checkDigit) {
                result = true;
            }
        } else {
            throw new Error('The supplied credit card number is not of type Number.');
        }
        return result;
    },
    sumOfDigits: function(number) {
        if (typeof number === 'number') {
            var sum = 0;
            while (number !== 0) {
                sum += number % 10;
                number = Math.floor(number / 10);
            }
            return sum;
        } else {
            throw new Error('Parameter number must be of Number type.');
        }
    }
}