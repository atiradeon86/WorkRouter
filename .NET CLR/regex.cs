// See https://aka.ms/new-console-template for more information
using System.Text.RegularExpressions;
using System;
using System.Collections.Generic;
using System.Reflection.Metadata.Ecma335;

namespace Bryan
{
    public class Regex4Sql
    {
        // Email testing with regex, returns E-mail Address or Bad status
        public static string EmailTesting(string DataString)
        {
            Regex reg =  new Regex("(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])");
            bool TestResult = reg.IsMatch(DataString);
            if (TestResult) {
                return DataString;
            }
            string status = "Bad";
            return status;
        }
    }
    public class UniversalRegex4Sql
    {
        // UniversalRegex with MatchCollection
        public static string Regex(string DataString,string pattern)
        {
            Regex reg = new Regex(pattern);
            string s = "";
            MatchCollection matches = reg.Matches(DataString);
            for (int count = 0; count < matches.Count; count++)
            {
                s += matches[count].Value;
            }
             return s;
        }
    }
}