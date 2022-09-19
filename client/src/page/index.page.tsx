import React, { useEffect } from "react";
import { useRecoilState } from "recoil";
import MyCalendar from "../components/Calendar";
import DurationSelector from "../components/DurationSelector";
import SelectedDuration from "../components/selectedDuration";
import { TimeSlotList } from "../components/TimeSlotList";
import { DateState, DurationState } from "../store";
import actionCable from "actioncable";
import { toast } from "react-toastify";
import { getAvailableSlots } from "../api";
import { useQuery } from "@tanstack/react-query";
import Loader from "../components/Loader";

type Props = {};

export default function IndexPage({}: Props) {
  const cable = actionCable.createConsumer("ws://localhost:3000/cable");
  const [date] = useRecoilState(DateState);
  const dateInString = date.toISOString().split("T")[0];
  const [duration] = useRecoilState(DurationState);
  const { data, isLoading, isSuccess, refetch } = useQuery(
    ["timeSlots", { dateInString, duration }],
    () => getAvailableSlots(dateInString, duration)
  );
  useEffect(() => {
    cable.subscriptions.create(
      {
        channel: "SlotBookerChannel",
        day: date,
      },
      {
        received(res) {
          toast.success(res.message, {
            position: "bottom-right",
            autoClose: 5000,
            hideProgressBar: false,
            toastId: "slotBooked",

           });
          refetch()
        },
      }
    );
  }, [cable.subscriptions, date]);


  return (
    <div>
      <SelectedDuration />
      <div className="pt-[50px]">
        <DurationSelector />
        <div className="md:w-3/4 mx-auto ">
          <div className=" px-4">
            <div className="flex-none lg:flex ">
              <MyCalendar />

              {isLoading &&<div className="md:w-1/3 mx-auto"><Loader /> </div>}
              {isSuccess && <TimeSlotList timeSlots={data.available_slots} />}
              {/* <TimeSlotList /> */}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
