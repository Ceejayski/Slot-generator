import React from "react";
import { useRecoilState } from "recoil";
import { DurationState } from "../store";
import DurationSelector from "./DurationSelector";

type Props = {};

export default function SelectedDuration({}: Props) {
  const [duration, setDuration] = useRecoilState(DurationState);

  return (
    <div className="selected-duration w-full w-100 py-4 flex justify-center ">
      <div className="bg-blue-400 py-3 px-4 text-white">
        <p className="text-white text-center">Selected Duration</p>
        <div className="flex justify-center align-items-center">
          <h1 className="font-sans font-bold text-3xl "> {duration} </h1>
          <h6>minutes</h6>
        </div>
        <p className="italic text-sm" >
          You can change the duration by selecting a different option from the
          dropdown
        </p>
      </div>
    </div>
  );
}
