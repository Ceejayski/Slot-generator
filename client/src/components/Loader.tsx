import React from 'react'

type Props = {}

export default function Loader({}: Props) {
  return (
    <>
      <div className="flex justify-center items-center h-full">
        <div className="animate-spin rounded-full h-24 w-24 border-b-2 border-gray-900"></div>
      </div>
    </>
  )
}
