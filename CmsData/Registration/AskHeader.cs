using System.ComponentModel;
using System.Text;
using System.Xml;
using System.Xml.Linq;
using CmsData.API;
using UtilityExtensions;

namespace CmsData.Registration
{
    public class AskHeader : Ask
    {
        public override string Help => @"
Displays the label text (can include HTML) on the registration page.
This can be used to separate sections.
";

        [DisplayName("Text/HTML")]
        public string Label { get; set; }
        public AskHeader() : base("AskHeader") { }
        public static AskHeader Parse(Parser parser)
        {
            var r = new AskHeader();
            parser.GetBool();
            r.Label = parser.GetLabel("Header");
            return r;
        }
        public override void Output(StringBuilder sb)
        {
            Settings.AddValueCk(0, sb, "AskHeader", true);
            if (!Label.HasValue())
                Label = "Header";
            Settings.AddValueCk(1, sb, "Label", Label);
            sb.AppendLine();
        }
        public override void WriteXml(APIWriter w)
        {
            if (!Label.HasValue())
                Label = "Header";
            w.AddCdata(Type, Label);
        }
        public new static AskHeader ReadXml(XElement e)
        {
            var h = new AskHeader() { Label = e.Value };
            return h;
        }
    }
}