(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	instrument4 - instrument
	image0 - mode
	thermograph1 - mode
	spectrograph2 - mode
	Star2 - direction
	GroundStation3 - direction
	GroundStation5 - direction
	Star6 - direction
	GroundStation7 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	Star14 - direction
	GroundStation1 - direction
	Star11 - direction
	Star8 - direction
	Star12 - direction
	Star0 - direction
	GroundStation4 - direction
	GroundStation13 - direction
	Planet15 - direction
	Planet16 - direction
	Planet17 - direction
	Phenomenon18 - direction
	Phenomenon19 - direction
	Planet20 - direction
	Star21 - direction
	Planet22 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation1)
	(supports instrument1 thermograph1)
	(supports instrument1 image0)
	(supports instrument1 spectrograph2)
	(calibration_target instrument1 Star12)
	(supports instrument2 spectrograph2)
	(supports instrument2 thermograph1)
	(calibration_target instrument2 Star11)
	(calibration_target instrument2 Star8)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star12)
	(supports instrument3 image0)
	(supports instrument3 thermograph1)
	(supports instrument3 spectrograph2)
	(calibration_target instrument3 Star8)
	(calibration_target instrument3 Star12)
	(supports instrument4 thermograph1)
	(supports instrument4 image0)
	(supports instrument4 spectrograph2)
	(calibration_target instrument4 GroundStation13)
	(calibration_target instrument4 GroundStation4)
	(calibration_target instrument4 Star0)
	(calibration_target instrument4 Star12)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation7)
)
(:goal (and
	(have_image Planet15 image0)
	(have_image Planet16 thermograph1)
	(have_image Planet17 thermograph1)
	(have_image Phenomenon18 spectrograph2)
	(have_image Phenomenon19 thermograph1)
	(have_image Planet20 spectrograph2)
	(have_image Star21 image0)
	(have_image Planet22 spectrograph2)
))

)
