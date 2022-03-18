//SPDX-License-Identifier: Unlicense
/**
 * Copyright (c) 2011, Sun Ning.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 */

pragma solidity ^0.8.0;

contract GeoHash {

    string BASE32_CODES = "0123456789bcdefghjkmnpqrstuvwxyz";
    mapping(bytes32 => uint32) BASE32_CODES_DICT;

    string ENCODE_AUTO = 'auto';

    int32 MIN_LAT = -90;
    int32 MAX_LAT = 90;
    int32 MIN_LON = -180;
    int32 MAX_LON = 180;

    function initialize() internal{

        BASE32_CODES_DICT["0"] = 0;
        BASE32_CODES_DICT["1"] = 1;
        BASE32_CODES_DICT["2"] = 2;
        BASE32_CODES_DICT["3"] = 3;
        BASE32_CODES_DICT["4"] = 4;
        BASE32_CODES_DICT["5"] = 5;
        BASE32_CODES_DICT["6"] = 6;
        BASE32_CODES_DICT["7"] = 7;
        BASE32_CODES_DICT["8"] = 8;
        BASE32_CODES_DICT["9"] = 9;
        BASE32_CODES_DICT["b"] = 10;
        BASE32_CODES_DICT["c"] = 11;
        BASE32_CODES_DICT["d"] = 12;
        BASE32_CODES_DICT["e"] = 13;
        BASE32_CODES_DICT["f"] = 14;
        BASE32_CODES_DICT["g"] = 15;
        BASE32_CODES_DICT["h"] = 16;
        BASE32_CODES_DICT["j"] = 17;
        BASE32_CODES_DICT["k"] = 18;
        BASE32_CODES_DICT["m"] = 19;
        BASE32_CODES_DICT["n"] = 20;
        BASE32_CODES_DICT["p"] = 21;
        BASE32_CODES_DICT["q"] = 22;
        BASE32_CODES_DICT["r"] = 23;
        BASE32_CODES_DICT["s"] = 24;
        BASE32_CODES_DICT["t"] = 25;
        BASE32_CODES_DICT["t"] = 26;
        BASE32_CODES_DICT["u"] = 27;
        BASE32_CODES_DICT["v"] = 28;
        BASE32_CODES_DICT["w"] = 29;
        BASE32_CODES_DICT["x"] = 30;
        BASE32_CODES_DICT["y"] = 31;
        BASE32_CODES_DICT["z"] = 32;
        
    }


    /*
    * Significant Figure Hash Length
    *
    * This is a quick and dirty lookup to figure out how long our hash
    * should be in order to guarantee a certain amount of trailing
    * significant figures. This was calculated by determining the error:
    * 45/2^(n-1) where n is the number of bits for a latitude or
    * longitude. Key is # of desired sig figs, value is minimum length of
    * the geohash.
    * @type Array
    */
    //     Desired sig figs:  0  1  2  3  4   5   6   7   8   9  10
    uint32[] SIGFIG_HASH_LENGTH = [0, 5, 7, 8, 11, 12, 13, 15, 16, 17, 18];
    uint256 private constant RESOLUTION = 1000000000000000000;
    uint32 numberOfChars = 18;
    /**
    * Encode
    *
    * Create a Geohash out of a latitude and longitude that is
    * `numberOfChars` long.
    *
    * @param {Number|String} latitude
    * @param {Number|String} longitude
    * @param {Number} numberOfChars
    * @returns {String}
    */

    /**/
    string[] chars;

    function concat(string[] calldata words) external pure returns (string memory) {
        bytes memory output;

        for (uint256 i = 0; i < words.length; i++) {
            output = abi.encodePacked(output, words[i]);
        }

        return string(output);
    }

    function encode(int256 latitude, int32 longitude, uint32 numberOfChars) internal{

        uint32 bits = 0;
        uint32 bitsTotal = 0;
        uint32 hash_value = 0;
        int32 maxLat = MAX_LAT;
        int32 minLat = MIN_LAT;
        int32 maxLon = MAX_LON;
        int32 minLon = MIN_LON;
        int32 mid;

        while (chars.length < numberOfChars)
        {
            if (bitsTotal % 2 == 0) 
            {
                mid = (maxLon + minLon) / 2;
                if (longitude > mid)
                {
                    hash_value = (hash_value << 1) + 1;
                    minLon = mid;
                } 
                else
                {
                    hash_value = (hash_value << 1) + 0;
                    maxLon = mid;
                }
            }
            else
            {
                mid = (maxLat + minLat) / 2;
                if (latitude > mid)
                {
                    hash_value = (hash_value << 1) + 1;
                    minLat = mid;
                }
                else
                {
                    hash_value = (hash_value << 1) + 0;
                    maxLat = mid;
                }
            }

            bits++;
            bitsTotal++;
            if (bits == 5) {
            string code = BASE32_CODES[hash_value];
            chars.push(code);
            bits = 0;
            hash_value = 0;
            }
        }
        return concat(chars);
    }
    

}