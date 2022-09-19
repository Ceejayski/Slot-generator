const API = "http://localhost:3000/api";
export const getAvailableSlots = async (date: string, duration: number) => {
  const response = await fetch(
    `${API}/book_slots/query?day=${date}&duration=${duration}`
  );
  const data = await response.json();
  return data;
};

export const bookSlot = async (
  body: {
    slot: string,
  duration: number,
  name: string
  }
) => {
  const { slot, duration, name } = body;
  const response = await fetch(`${API}/book_slots`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      book_slot: {
        slot,
        duration,
        name,
      },
    }),
  });
  const data = await response.json();
  return data;
};
