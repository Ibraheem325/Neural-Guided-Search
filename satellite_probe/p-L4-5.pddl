(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	satellite2 - satellite
	instrument4 - instrument
	infrared1 - mode
	image0 - mode
	infrared3 - mode
	thermograph2 - mode
	Star0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star4 - direction
	Star8 - direction
	Star12 - direction
	Star17 - direction
	Star19 - direction
	GroundStation23 - direction
	GroundStation24 - direction
	GroundStation16 - direction
	GroundStation7 - direction
	Star21 - direction
	Star13 - direction
	GroundStation18 - direction
	Star5 - direction
	Star22 - direction
	Star11 - direction
	GroundStation9 - direction
	Star14 - direction
	Star6 - direction
	Star3 - direction
	Star15 - direction
	GroundStation10 - direction
	Star20 - direction
	Phenomenon25 - direction
	Star26 - direction
	Planet27 - direction
	Star28 - direction
	Phenomenon29 - direction
	Planet30 - direction
	Phenomenon31 - direction
	Phenomenon32 - direction
	Planet33 - direction
	Phenomenon34 - direction
	Planet35 - direction
	Planet36 - direction
	Star37 - direction
	Phenomenon38 - direction
	Star39 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 infrared1)
	(calibration_target instrument0 Star3)
	(calibration_target instrument0 GroundStation16)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 Star13)
	(calibration_target instrument0 GroundStation18)
	(supports instrument1 infrared1)
	(supports instrument1 infrared3)
	(supports instrument1 thermograph2)
	(calibration_target instrument1 Star21)
	(calibration_target instrument1 GroundStation7)
	(calibration_target instrument1 Star13)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star39)
	(supports instrument2 infrared1)
	(supports instrument2 image0)
	(supports instrument2 infrared3)
	(calibration_target instrument2 Star22)
	(calibration_target instrument2 Star14)
	(calibration_target instrument2 Star5)
	(calibration_target instrument2 Star21)
	(supports instrument3 image0)
	(supports instrument3 thermograph2)
	(calibration_target instrument3 Star22)
	(calibration_target instrument3 Star5)
	(calibration_target instrument3 GroundStation18)
	(calibration_target instrument3 Star13)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet35)
	(supports instrument4 thermograph2)
	(calibration_target instrument4 Star20)
	(calibration_target instrument4 GroundStation10)
	(calibration_target instrument4 Star15)
	(calibration_target instrument4 Star3)
	(calibration_target instrument4 Star6)
	(calibration_target instrument4 Star14)
	(calibration_target instrument4 GroundStation9)
	(calibration_target instrument4 Star11)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation24)
)
(:goal (and
	(pointing satellite2 Star28)
	(have_image Phenomenon25 infrared3)
	(have_image Star26 infrared3)
	(have_image Planet27 infrared1)
	(have_image Star28 infrared3)
	(have_image Phenomenon29 infrared3)
	(have_image Planet30 thermograph2)
	(have_image Phenomenon31 thermograph2)
	(have_image Phenomenon32 image0)
	(have_image Planet33 infrared3)
	(have_image Phenomenon34 infrared3)
	(have_image Planet35 infrared3)
	(have_image Planet36 image0)
	(have_image Star37 thermograph2)
	(have_image Phenomenon38 infrared3)
	(have_image Star39 infrared3)
))

)
