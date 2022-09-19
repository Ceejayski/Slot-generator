import * as React from "react";
import TimeSlot from "./TimeSlot";

export interface ITimeSlotListProps {
  timeSlots: string[];
}

export function TimeSlotList(props: ITimeSlotListProps) {
  const { timeSlots } = props;
  return (
    <div className="time-slot__container lg:w-1/3 mx-auto">
      {timeSlots.map((item, index) =>
        <TimeSlot key={index} time={item} />
      )}
    </div>
  );
}
