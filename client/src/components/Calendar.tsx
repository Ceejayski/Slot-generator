import React from "react";
import Calendar from "react-calendar";
import { useRecoilState } from "recoil";
import { DateState } from "../store";

type Props = {};

export default function MyCalendar({}: Props) {
  const [date, setDate] = useRecoilState(DateState);

  return (
    <div>
      <div className="shadow-xl p-3 my-3">
        <Calendar onChange={setDate} value={date} />
      </div>
    </div>
  );
}
