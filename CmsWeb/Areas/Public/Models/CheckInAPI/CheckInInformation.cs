﻿using System.Collections.Generic;

namespace CmsWeb.CheckInAPI
{
    public class CheckInInformation
    {
        public List<CheckInSettingsEntry> settings;
        public List<CheckInCampus> campuses;
        public List<CheckInLabelFormat> labels;

        public CheckInInformation(List<CheckInSettingsEntry> settings, List<CheckInCampus> campuses, List<CheckInLabelFormat> labels)
        {
            this.settings = settings;
            this.campuses = campuses;
            this.labels = labels;

            if (this.campuses.Count > 0)
            {
                this.campuses.Insert(0, new CheckInCampus() { id = 0, name = "All Campuses" });
            }
        }
    }
}