import React from "react";
import { useRecoilState } from "recoil";
import { SlotState, TimeZoneState } from "../store";
import TimeSlotModal from "./TimeSlotModal";

type Props = {
  time: string;
};

export default function TimeSlot({ time }: Props) {
  const [slot, setSlot] = useRecoilState(SlotState);
  const [timezone] = useRecoilState(TimeZoneState);
  const [modal, setModal] = React.useState(false);

  function getTime(time: string) {
    const date = new Date(time);
    return date.toLocaleTimeString("en-US", { timeZone: timezone });
  }

  function handleClick() {
    if (slot === time) {
      setSlot("");
    } else {
      setSlot(time);
      setModal(true);
    }
  }

  const className =
    slot == time
      ? "bg-blue-600 hover:bg-blue-700 text-white  "
      : "text-black hover:text-white";

  return (
    <>
      <button
        onClick={handleClick}
        className={`${className} hover:bg-blue-300 text-sm font-bold w-1/3 py-4 m-[2px]`}
      >
        {getTime(time)}
      </button>
      <TimeSlotModal visible={modal} setVisible={setModal} />
    </>
  );
}
