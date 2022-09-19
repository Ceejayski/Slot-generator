import { atom } from "recoil";

export const DateState = atom({ key: "date", default: new Date() });

export const DurationState = atom({
  key: "duration",
  default: 30,
});

export const SlotState = atom({
  key: "slot",
  default: ""
});

export const TimeZoneState = atom({
  key: "timeZone",
  default: "UTC"
});
