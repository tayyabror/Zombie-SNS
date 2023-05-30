# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Survivor, type: :model do
  it "is valid with valid attributes" do
    survivor = Survivor.new(
      name: "John Doe",
      age: 25,
      gender: "Male",
      latitude: -80,
      longitude: 150
    )
    
    expect(survivor).to be_valid
  end

  it "is invalid without a name" do
    survivor = Survivor.new(
      age: 25,
      gender: "Male",
      latitude: 123.456,
      longitude: 456.789
    )

    expect(survivor).to be_invalid
    expect(survivor.errors[:name]).to include("can't be blank")
  end

  it "is invalid without an age" do
    survivor = Survivor.new(
      name: "John Doe",
      gender: "Male",
      latitude: 123.456,
      longitude: 456.789
    )

    expect(survivor).to be_invalid
    expect(survivor.errors[:age]).to include("can't be blank")
  end

  it "is invalid without a gender" do
    survivor = Survivor.new(
      name: "John Doe",
      age: 25,
      latitude: 123.456,
      longitude: 456.789
    )

    expect(survivor).to be_invalid
    expect(survivor.errors[:gender]).to include("can't be blank")
  end

  it "is invalid without a latitude" do
    survivor = Survivor.new(
      name: "John Doe",
      age: 25,
      gender: "Male",
      longitude: 456.789
    )

    expect(survivor).to be_invalid
    expect(survivor.errors[:latitude]).to include("can't be blank")
  end

  it "is invalid without a longitude" do
    survivor = Survivor.new(
      name: "John Doe",
      age: 25,
      gender: "Male",
      latitude: 123.456
    )

    expect(survivor).to be_invalid
    expect(survivor.errors[:longitude]).to include("can't be blank")
  end

  it "is invalid when the same survivor is reported multiple times" do
    survivor = Survivor.new(
      name: "John Doe",
      age: 25,
      gender: "Male",
      latitude: 86,
      longitude: 97,
      reported_by: [12, 12]
    )

    expect(survivor).to be_invalid
    expect(survivor.errors[:reported_by]).to include("contains duplicate values")
  end

  it "is infected if five or more survivors reported" do
    survivor = Survivor.new(
      name: "John Doe",
      age: 25,
      gender: "Male",
      latitude: -80,
      longitude: 150,
      reported_by: [12, 14, 34, 56, 78]
    )

    expect(survivor).to be_valid
    survivor.save
    expect(survivor.infected).to eq(true)
  end
end
