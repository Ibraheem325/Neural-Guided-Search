(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	satellite1 - satellite
	instrument4 - instrument
	spectrograph2 - mode
	image0 - mode
	infrared3 - mode
	thermograph1 - mode
	Star0 - direction
	Star1 - direction
	GroundStation5 - direction
	GroundStation11 - direction
	Star13 - direction
	Star3 - direction
	Star10 - direction
	GroundStation2 - direction
	Star4 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	GroundStation12 - direction
	GroundStation6 - direction
	Planet14 - direction
	Phenomenon15 - direction
	Planet16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 Star13)
	(supports instrument1 image0)
	(calibration_target instrument1 GroundStation2)
	(calibration_target instrument1 GroundStation9)
	(calibration_target instrument1 Star10)
	(calibration_target instrument1 Star3)
	(supports instrument2 image0)
	(supports instrument2 spectrograph2)
	(calibration_target instrument2 Star4)
	(calibration_target instrument2 GroundStation7)
	(supports instrument3 thermograph1)
	(supports instrument3 infrared3)
	(calibration_target instrument3 GroundStation8)
	(calibration_target instrument3 GroundStation7)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation8)
	(supports instrument4 thermograph1)
	(calibration_target instrument4 GroundStation6)
	(calibration_target instrument4 GroundStation12)
	(calibration_target instrument4 GroundStation9)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star3)
)
(:goal (and
	(pointing satellite0 Star10)
	(have_image Planet14 thermograph1)
	(have_image Phenomenon15 image0)
	(have_image Planet16 thermograph1)
	(have_image Planet17 image0)
))

)
