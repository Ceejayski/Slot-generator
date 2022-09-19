import React from "react";

type Props = {};

export default function NavBar(props: Props) {
  return (
    <>
      <header>
        <nav className="font-sans text-center py-4 px-6 shadow w-full">
          <h1 className="text-2xl text-grey-600 "> WhareHouse Booking App</h1>
        </nav>
      </header>
    </>
  );
}
