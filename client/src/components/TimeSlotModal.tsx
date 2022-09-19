import {
  CModal,
  CModalHeader,
  CModalTitle,
  CModalBody,
  CModalFooter,
  CButton,
  CFormInput,
  CFormLabel,
  CFormText,
  CForm
} from "@coreui/react";
import React from "react";
import { toast} from "react-toastify";
import {
  useMutation,
  useQueryClient
} from '@tanstack/react-query'
import { useRecoilState } from "recoil";
import { DurationState, SlotState, TimeZoneState, DateState } from "../store";
import moment from "moment-timezone";
import { bookSlot } from "../api";

type Props = {
  visible: boolean;
  setVisible: (visible: boolean) => void;
};

export default function TimeSlotModal({ visible, setVisible }: Props) {
  const [duration] = useRecoilState(DurationState);
  const [slot, setSlot] = useRecoilState(SlotState);
  const [date] = useRecoilState(DateState);
  const [timezone] = useRecoilState(TimeZoneState);
  const dateInString = date.toISOString().split("T")[0];

  const [name, setName] = React.useState("");
  const queryClient = useQueryClient()
  const { mutate: createSlot } = useMutation(
    (data: any) => bookSlot(data),
    {

      onSuccess: () => {
        toast.success("Slot booked successfully");
        queryClient.invalidateQueries(["timeSlots", { dateInString, duration }])
      },
      onError: (error: any) => {
        toast.error(error.message)
      }
    }
  )

  const startDate = moment(slot)
    .tz(timezone)
    .format("MMM. D, YYYY [at] h:mm A z");
  const endDate = moment(slot)
    .tz(timezone)
    .add(duration, "minutes")
    .format("MMM. D, YYYY [at] h:mm A z");
  const handleCancel = () => {
    setVisible(false);
    setSlot("");
  };

  const handleSave = (e: any) => {
    e.preventDefault();
    if(name != "" && name != null){
      setVisible(false);
      setSlot("");
      createSlot({name, slot, duration})
    }else {
      toast.error("Please enter company name")
    }
  };
  return (
    <CModal alignment="center" visible={visible} onClose={handleCancel}>
      <CForm onSubmit={handleSave}>
      <CModalHeader>
        <CModalTitle>Confirm Booking</CModalTitle>
      </CModalHeader>
      <CModalBody>
        You are about to book a slot from{" "}
        <span className="font-bold">{startDate}</span> to{" "}
        <span className="font-bold">{endDate}</span>
        <div className="my-3">
          <CFormLabel htmlFor="exampleInputEmail1">Company Name</CFormLabel>
          <CFormInput
            type="text"
            id="exampleInputEmail1"
            aria-describedby="emailHelp"
            placeholder="Enter company name"
            value={name}
            onChange={(e) => setName(e.target.value)}
          />
          <CFormText id="emailHelp">
            We'll never share your email with anyone else.
          </CFormText>
        </div>
      </CModalBody>
      <CModalFooter>
        <CButton color="secondary" onClick={handleCancel}>
          Close
        </CButton>
        <CButton color="primary" type="submit">Save changes</CButton>
      </CModalFooter>
      </CForm>
    </CModal>
  );
}
