import React, { useEffect } from "react";
import { GroupBase } from "react-select";
import CreatableSelect from "react-select/creatable";
import { useRecoilState } from "recoil";
import { DurationState } from "../store";

type Props = {};

interface OptionType {
  value: string;
  label: string;
}

export default function DurationSelector({}: Props) {
  const [duration, setDuration] = useRecoilState(DurationState);

  useEffect(() => {
    console.log("here");
  }, [duration]);

  const option = [
    { value: 120, label: "2 hours" },

    { value: 90, label: "1 hour, 30 minutes" },
    { value: 60, label: "1 hour" },
    { value: 45, label: "45 minutes" },
    { value: 30, label: "30 minutes" },
    { value: 15, label: "15 minutes" },
  ];

  function handleChange(e: any) {
    // console.log(e.value)
    setDuration(e.value);
    // console.log(duration)
  }

  return (
    <div className="w-3/4 mx-auto my-4" >

      <CreatableSelect
        options={option as any}
        isClearable
        onChange={handleChange}
        placeholder="Select duration"
        value={{value: duration, label: `${duration} minutes`}}
      />
    </div>
  );
}
