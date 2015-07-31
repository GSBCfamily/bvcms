﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Linq;
using CmsData.API;
using UtilityExtensions;

namespace CmsData.Registration
{
	public class AskText : Ask
	{
	    public override string Help => @"
These questions can be answered with text on multiple lines.

The Question should be fairly short (25 characters or so)
but long enough for you and your registrant to know what it refers to. 
Note, this will be used as a column header on an Excel spreadsheet.

If you need a long explanation assoicated with your question, put that in as an Instruction above the question.
";
	    public List<AskExtraQuestions.ExtraQuestion> list { get; private set; }

		public AskText()
			: base("AskText")
		{
			list = new List<AskExtraQuestions.ExtraQuestion>();
		}
		public override void Output(StringBuilder sb)
		{
			if (list.Count == 0)
				return;
			Settings.AddValueNoCk(0, sb, "Text", "");
			foreach (var q in list)
				q.Output(sb);
			sb.AppendLine();
		}
		public static AskText Parse(Parser parser)
		{
			var tx = new AskText();
			parser.lineno++;
			if (parser.curr.indent == 0)
				return tx;
			var startindent = parser.curr.indent;
			while (parser.curr.indent == startindent)
			{
				var q = AskExtraQuestions.ExtraQuestion.Parse(parser, startindent);
				tx.list.Add(q);
			}
			return tx;
		}
	    public override void WriteXml(APIWriter w)
	    {
			if (list.Count == 0)
				return;
	        w.Start(Type);
	        foreach (var q in list)
                w.Add("ExtraQuestion", q.Question);
	        w.End();
	    }
	    public new static AskText ReadXml(XElement e)
	    {
	        var t = new AskText();
            foreach(var ee in e.Elements("Question"))
                t.list.Add(AskExtraQuestions.ExtraQuestion.ReadXml(ee));
	        return t;
	    }
	}
}
