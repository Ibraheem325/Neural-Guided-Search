(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	spectrograph0 - mode
	spectrograph4 - mode
	infrared3 - mode
	image1 - mode
	thermograph2 - mode
	Star2 - direction
	Star5 - direction
	GroundStation11 - direction
	GroundStation13 - direction
	GroundStation1 - direction
	Star9 - direction
	GroundStation8 - direction
	Star4 - direction
	Star0 - direction
	Star3 - direction
	GroundStation7 - direction
	Star12 - direction
	GroundStation10 - direction
	Star6 - direction
	Planet14 - direction
	Planet15 - direction
	Phenomenon16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 spectrograph4)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 Star3)
	(calibration_target instrument0 Star9)
	(calibration_target instrument0 GroundStation1)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 Star4)
	(calibration_target instrument1 GroundStation8)
	(calibration_target instrument1 Star0)
	(calibration_target instrument1 Star12)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star6)
	(supports instrument2 image1)
	(supports instrument2 thermograph2)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 GroundStation7)
	(calibration_target instrument2 Star3)
	(calibration_target instrument2 Star0)
	(supports instrument3 thermograph2)
	(supports instrument3 infrared3)
	(supports instrument3 image1)
	(calibration_target instrument3 Star6)
	(calibration_target instrument3 GroundStation10)
	(calibration_target instrument3 Star12)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation7)
)
(:goal (and
	(have_image Planet14 image1)
	(have_image Planet15 infrared3)
	(have_image Phenomenon16 image1)
	(have_image Star17 thermograph2)
))

)
