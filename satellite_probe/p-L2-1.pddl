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
	instrument5 - instrument
	thermograph2 - mode
	image1 - mode
	thermograph0 - mode
	Star1 - direction
	Star7 - direction
	GroundStation8 - direction
	GroundStation13 - direction
	GroundStation9 - direction
	Star6 - direction
	Star3 - direction
	Star4 - direction
	GroundStation0 - direction
	Star5 - direction
	Star12 - direction
	GroundStation10 - direction
	GroundStation2 - direction
	Star14 - direction
	GroundStation11 - direction
	Planet15 - direction
	Planet16 - direction
	Phenomenon17 - direction
	Planet18 - direction
	Planet19 - direction
	Phenomenon20 - direction
	Planet21 - direction
	Phenomenon22 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 image1)
	(calibration_target instrument0 Star14)
	(calibration_target instrument0 Star12)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 Star6)
	(supports instrument1 thermograph2)
	(supports instrument1 image1)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 Star12)
	(calibration_target instrument1 Star3)
	(calibration_target instrument1 Star6)
	(calibration_target instrument1 Star14)
	(supports instrument2 thermograph0)
	(supports instrument2 image1)
	(calibration_target instrument2 Star4)
	(calibration_target instrument2 Star3)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation8)
	(supports instrument3 thermograph2)
	(supports instrument3 thermograph0)
	(calibration_target instrument3 Star5)
	(calibration_target instrument3 GroundStation0)
	(calibration_target instrument3 GroundStation10)
	(supports instrument4 thermograph2)
	(supports instrument4 thermograph0)
	(supports instrument4 image1)
	(calibration_target instrument4 Star14)
	(calibration_target instrument4 GroundStation10)
	(calibration_target instrument4 Star12)
	(supports instrument5 thermograph0)
	(supports instrument5 thermograph2)
	(supports instrument5 image1)
	(calibration_target instrument5 GroundStation11)
	(calibration_target instrument5 Star14)
	(calibration_target instrument5 GroundStation2)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet15)
)
(:goal (and
	(have_image Planet15 thermograph2)
	(have_image Planet16 thermograph2)
	(have_image Phenomenon17 image1)
	(have_image Planet18 thermograph0)
	(have_image Planet19 image1)
	(have_image Phenomenon20 thermograph0)
	(have_image Planet21 thermograph0)
	(have_image Phenomenon22 image1)
))

)
