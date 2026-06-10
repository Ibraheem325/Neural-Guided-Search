(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	infrared3 - mode
	spectrograph2 - mode
	thermograph1 - mode
	image0 - mode
	Star0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation7 - direction
	Star10 - direction
	GroundStation11 - direction
	Star13 - direction
	GroundStation14 - direction
	Star16 - direction
	Star17 - direction
	GroundStation19 - direction
	Star18 - direction
	Star4 - direction
	GroundStation15 - direction
	GroundStation12 - direction
	GroundStation6 - direction
	GroundStation9 - direction
	GroundStation5 - direction
	GroundStation8 - direction
	Star20 - direction
	Phenomenon21 - direction
	Planet22 - direction
	Star23 - direction
	Phenomenon24 - direction
	Planet25 - direction
	Planet26 - direction
	Phenomenon27 - direction
	Planet28 - direction
	Phenomenon29 - direction
	Phenomenon30 - direction
	Phenomenon31 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph2)
	(supports instrument0 image0)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 GroundStation15)
	(calibration_target instrument0 Star18)
	(supports instrument1 image0)
	(calibration_target instrument1 GroundStation6)
	(calibration_target instrument1 GroundStation12)
	(calibration_target instrument1 GroundStation15)
	(supports instrument2 infrared3)
	(calibration_target instrument2 GroundStation5)
	(calibration_target instrument2 GroundStation9)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation9)
	(supports instrument3 spectrograph2)
	(supports instrument3 thermograph1)
	(calibration_target instrument3 GroundStation8)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation2)
)
(:goal (and
	(pointing satellite0 Phenomenon29)
	(have_image Star20 spectrograph2)
	(have_image Phenomenon21 infrared3)
	(have_image Planet22 thermograph1)
	(have_image Star23 image0)
	(have_image Phenomenon24 infrared3)
	(have_image Planet25 infrared3)
	(have_image Planet26 infrared3)
	(have_image Phenomenon27 spectrograph2)
	(have_image Planet28 thermograph1)
	(have_image Phenomenon29 thermograph1)
	(have_image Phenomenon30 image0)
	(have_image Phenomenon31 spectrograph2)
))

)
