(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	thermograph4 - mode
	image0 - mode
	spectrograph3 - mode
	spectrograph1 - mode
	spectrograph2 - mode
	GroundStation1 - direction
	GroundStation4 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	Star9 - direction
	GroundStation11 - direction
	GroundStation13 - direction
	GroundStation14 - direction
	GroundStation16 - direction
	Star17 - direction
	Star0 - direction
	GroundStation12 - direction
	Star6 - direction
	Star18 - direction
	Star15 - direction
	GroundStation5 - direction
	Star3 - direction
	GroundStation2 - direction
	GroundStation10 - direction
	Star19 - direction
	Planet20 - direction
	Phenomenon21 - direction
	Planet22 - direction
	Phenomenon23 - direction
	Planet24 - direction
	Star25 - direction
	Planet26 - direction
	Planet27 - direction
	Star28 - direction
	Phenomenon29 - direction
	Star30 - direction
)
(:init
	(supports instrument0 spectrograph3)
	(supports instrument0 image0)
	(calibration_target instrument0 Star3)
	(supports instrument1 spectrograph2)
	(calibration_target instrument1 Star6)
	(calibration_target instrument1 GroundStation12)
	(calibration_target instrument1 Star0)
	(supports instrument2 spectrograph3)
	(supports instrument2 thermograph4)
	(supports instrument2 spectrograph1)
	(calibration_target instrument2 GroundStation10)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 Star3)
	(calibration_target instrument2 GroundStation5)
	(calibration_target instrument2 Star15)
	(calibration_target instrument2 Star18)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star28)
	(supports instrument3 spectrograph2)
	(supports instrument3 image0)
	(calibration_target instrument3 Star19)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation14)
)
(:goal (and
	(have_image Planet20 spectrograph3)
	(have_image Phenomenon21 thermograph4)
	(have_image Planet22 spectrograph1)
	(have_image Phenomenon23 spectrograph1)
	(have_image Planet24 spectrograph3)
	(have_image Star25 image0)
	(have_image Planet26 spectrograph1)
	(have_image Planet27 thermograph4)
	(have_image Star28 image0)
	(have_image Phenomenon29 thermograph4)
	(have_image Star30 spectrograph1)
))

)
