(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	infrared3 - mode
	image0 - mode
	thermograph1 - mode
	spectrograph2 - mode
	Star0 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	GroundStation11 - direction
	GroundStation12 - direction
	GroundStation14 - direction
	GroundStation15 - direction
	Star17 - direction
	Star18 - direction
	GroundStation22 - direction
	Star23 - direction
	GroundStation19 - direction
	Star24 - direction
	Star21 - direction
	Star4 - direction
	Star1 - direction
	Star13 - direction
	Star10 - direction
	Star20 - direction
	Star16 - direction
	Planet25 - direction
	Planet26 - direction
	Phenomenon27 - direction
	Planet28 - direction
	Phenomenon29 - direction
	Planet30 - direction
	Planet31 - direction
	Star32 - direction
	Planet33 - direction
	Planet34 - direction
	Phenomenon35 - direction
	Phenomenon36 - direction
	Planet37 - direction
	Star38 - direction
	Planet39 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 image0)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 Star21)
	(calibration_target instrument0 Star24)
	(calibration_target instrument0 Star16)
	(calibration_target instrument0 Star13)
	(calibration_target instrument0 GroundStation19)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet37)
	(supports instrument1 thermograph1)
	(supports instrument1 infrared3)
	(calibration_target instrument1 Star13)
	(calibration_target instrument1 Star1)
	(supports instrument2 image0)
	(supports instrument2 infrared3)
	(calibration_target instrument2 Star10)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation9)
	(supports instrument3 thermograph1)
	(calibration_target instrument3 Star16)
	(calibration_target instrument3 Star20)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation2)
)
(:goal (and
	(pointing satellite2 Star38)
	(have_image Planet25 spectrograph2)
	(have_image Planet26 spectrograph2)
	(have_image Phenomenon27 image0)
	(have_image Planet28 infrared3)
	(have_image Phenomenon29 spectrograph2)
	(have_image Planet30 spectrograph2)
	(have_image Planet31 thermograph1)
	(have_image Star32 thermograph1)
	(have_image Planet33 infrared3)
	(have_image Planet34 image0)
	(have_image Phenomenon35 infrared3)
	(have_image Phenomenon36 image0)
	(have_image Planet37 infrared3)
	(have_image Star38 thermograph1)
	(have_image Planet39 thermograph1)
))

)
